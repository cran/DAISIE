//
//  Copyright (c) 2023, Hanno Hildenbrandt
//
//  Distributed under the Boost Software License, Version 1.0. (See
//  accompanying file LICENSE_1_0.txt or copy at
//  http://www.boost.org/LICENSE_1_0.txt)
//

#ifndef DAISIE_ODEINT_H_INCLUDED
#define DAISIE_ODEINT_H_INCLUDED

#include "config.h"
#include "DAISIE_types.h"
#include <boost/numeric/odeint.hpp>
#include <algorithm>
#include <stdexcept>
#include <memory>


#ifdef USE_BULRISCH_STOER_PATCH

#include <boost/units/quantity.hpp>
#include <boost/units/systems/si/dimensionless.hpp>

using bstime_t = boost::units::quantity<boost::units::si::dimensionless, double>;

#else // USE_BULRISCH_STOER_PATCH

// The default. Causes unitialized member m_last_dt in
// boost::odeint::bulrisch_stoer<>, declared in
// boost/numreic/odeint/stepper/bulrisch_stoer.hpp
using bstime_t = double;

#endif // USE_BULRISCH_STOER_PATCH


using namespace Rcpp;
using namespace boost::numeric::odeint;

// type of the ode state
using state_type = vector_t<double>;


// row-major matrix view into flat data
class mat_view
{
public:
  mat_view(double* data, int ncol) :
    sdata_(data), ncol_(ncol)
  {
  }

  double operator()(int col, int row) const
  {
    return *(sdata_ + row * ncol_ + col);
  }

  double& operator()(int col, int row)
  {
    return *(sdata_ + row * ncol_ + col);
  }

private:
  double* sdata_ = nullptr;
  const int ncol_ = 0;
};


// matrix view into flat data
class const_mat_view
{
public:
  const_mat_view(const double* data, int ncol) :
    sdata_(data), ncol_(ncol) {
  }

  double operator()(int col, int row) const {
    return *(sdata_ + row * ncol_ + col);
  }

private:
  const double* sdata_ = nullptr;
  const int ncol_ = 0;
};


// zero-value padded view into vector
template <int Pad>
class padded_vector_view
{
public:
  padded_vector_view(const double* data, int n) :
    sdata_(data - Pad), sn_(n + Pad) {
  }

  // returns 0.0 for indices 'i' outside [Pad, Pad + n)
  double operator[](int i) const {
    return (i >= Pad && i < sn_) ? *(sdata_ + i) : 0.0;
  }

private:
  const double* sdata_ = nullptr;  // sdata_[Pad] == data[0]
  const int sn_ = Pad;
};


// zer0-padded padded matrix view into flat data
template <int Pad>
class padded_mat_view
{
public:
  padded_mat_view(const double* data, int ncol, int nrow) :
    sdata_(data), ncol_(ncol), nrow_(nrow) {
  }

  // returns 0.0 for indices 'col' outside [Pad, Pad + ncol),
  // or 'row' outside [Pad, Pad + nrow)
  double operator()(int col, int row) const {
    row -= Pad;
    col -= Pad;
    return ((col >= 0) && (col < ncol_) && (row >=0) && (row < nrow_))
      ? *(sdata_ + row * ncol_ + col)
      : 0.0;
  }

private:
  const double* sdata_ = nullptr;
  const int ncol_ = 0;
  const int nrow_ = 0;
};


namespace daisie_odeint {

  extern double abm_factor;   // defined in DAISIE_CS.cpp


  template <typename Stepper, typename Rhs>
  inline void do_integrate(double atol, double rtol, Rhs rhs, state_type& y, double t0, double t1)
  {
    integrate_adaptive(make_controlled<Stepper>(atol, rtol), rhs, y, t0, t1, 0.1 * (t1 - t0));
  }


  template <size_t Steps, typename Rhs>
  inline void abm(Rhs rhs, state_type& y, double t0, double t1)
  {
    auto abm = adams_bashforth_moulton<Steps, state_type>{};
    abm.initialize(rhs, y, t0, abm_factor * (t1 - t0));
    integrate_const(abm, rhs, y, t0, t1, abm_factor * (t1 - t0));
  }


  template <size_t Steps, typename Rhs>
  inline void ab(Rhs rhs, state_type& y, double t0, double t1)
  {
    auto ab = adams_bashforth<Steps, state_type>{};
    ab.initialize(rhs, y, t0, abm_factor * (t1 - t0));
    integrate_const(ab, rhs, y, t0, t1, abm_factor * (t1 - t0));
  }


  namespace jacobian_policy {

    // Evaluator of the Jacobian for linear, time independent systems
    // dxdt = Ax => Jacobian = t(A)
    template <typename RHS>
    struct const_from_linear_rhs
    {
      explicit const_from_linear_rhs(RHS& rhs) : rhs_(rhs)
      {
      }

      void operator()(const vector_t<double>& x, matrix_t<double>& J, double t, vector_t<double>& /*dfdt*/)
      {
        if (!J_) {
          // once-only, generic evaluation

          J_ = std::make_unique<matrix_t<double>>(J.size1(), J.size2());
          auto single = vector_t<double>(x.size(), 0);
          auto dxdt = vector_t<double>(x.size());
          for (size_t i = 0; i < J.size1(); ++i) {
            single[i] = 1.0;
            auto col = ublas::matrix_column<matrix_t<double>>(*J_, i);
            std::copy(col.begin(), col.end(), dxdt.begin());
            rhs_(single, dxdt, 0);
            std::copy(dxdt.begin(), dxdt.end(), col.begin());
            single[i] = 0.0;
          }
        }
        J = *J_;
      }

      RHS& rhs_;
      std::unique_ptr<matrix_t<double>> J_;
  };

  }


  // wrapper around odeint::integrate
  // maps runtime stepper name -> compiletime odeint::stepper type
  template <typename Rhs>
  inline void integrate(
      const std::string& stepper,
      Rhs rhs,
      state_type& y,
      double t0,
      double t1,
      double atol,
      double rtol)
  {
    if ("odeint::runge_kutta_cash_karp54" == stepper) {
      do_integrate<runge_kutta_cash_karp54<state_type>>(atol, rtol, rhs, y, t0, t1);
    }
    else if ("odeint::runge_kutta_fehlberg78" == stepper) {
      do_integrate<runge_kutta_fehlberg78<state_type>>(atol, rtol, rhs, y, t0, t1);
    }
    else if ("odeint::runge_kutta_dopri5" == stepper) {
      do_integrate<runge_kutta_dopri5<state_type>>(atol, rtol, rhs, y, t0, t1);
    }
    else if ("odeint::bulirsch_stoer" == stepper) {
      // outlier in calling convention
      using stepper_t = bulirsch_stoer<state_type, double, state_type, bstime_t>;
      integrate_adaptive(stepper_t(atol, rtol), rhs, y, bstime_t{t0}, bstime_t{t1}, bstime_t{0.1 * (t1 - t0)});
    }
    else if (0 == stepper.compare(0, stepper.size() - 2, "odeint::adams_bashforth")) {
      const char steps = stepper.back();
      switch (steps) {
      case '1': ab<1>(rhs, y, t0, t1); break;
      case '2': ab<2>(rhs, y, t0, t1); break;
      case '3': ab<3>(rhs, y, t0, t1); break;
      case '4': ab<4>(rhs, y, t0, t1); break;
      case '5': ab<5>(rhs, y, t0, t1); break;
      case '6': ab<6>(rhs, y, t0, t1); break;
      case '7': ab<7>(rhs, y, t0, t1); break;
      case '8': ab<8>(rhs, y, t0, t1); break;
      default: throw std::runtime_error("DAISIE_odeint_helper::integrate: unsupported steps for admam_bashforth");
      }
    }
    else if (0 == stepper.compare(0, stepper.size() - 2, "odeint::adams_bashforth_moulton")) {
      const char steps = stepper.back();
      switch (steps) {
      case '1': abm<1>(rhs, y, t0, t1); break;
      case '2': abm<2>(rhs, y, t0, t1); break;
      case '3': abm<3>(rhs, y, t0, t1); break;
      case '4': abm<4>(rhs, y, t0, t1); break;
      case '5': abm<5>(rhs, y, t0, t1); break;
      case '6': abm<6>(rhs, y, t0, t1); break;
      case '7': abm<7>(rhs, y, t0, t1); break;
      case '8': abm<8>(rhs, y, t0, t1); break;
      default: throw std::runtime_error("DAISIE_odeint_helper::integrate: unsupported steps for admam_bashforth_moulton");
      }
    }
    else if ("odeint::rosenbrock4" == stepper) {
      // another outlier in calling convention
      using stepper_t = rosenbrock4<double>;
      using controlled_stepper_t = rosenbrock4_controller<stepper_t>;
      auto jac = typename Rhs::type::jacobian(rhs);
      auto sys = std::make_pair(std::ref(rhs), std::ref(jac));
      integrate_adaptive(controlled_stepper_t(atol, rtol), sys, y, t0, t1, 0.1 * (t1 - t0));
    }
    else {
      throw std::runtime_error("DAISIE_odeint_helper::integrate: unknown stepper");
    }
  }

}

#endif
