DAISIE_tutorial = function(os)
{
   filename = system.file("DAISIE_tutorial.pdf",package = "DAISIE")
   if(os == "windows" | os == "win")
   {
       shell.exec(filename)
   }
   if(os == "mac")
   {
       system(paste("open",filename,sep = " "))
   }
}