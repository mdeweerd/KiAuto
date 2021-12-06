#!/usr/bin/perl
while (1)
  {
   $a = `xdotool getwindowfocus getwindowname`;
   print $a;
   print "----\n";
   $a = `xdotool search --onlyvisible --name 'Pcbnew.*'`;
   print $a;
   sleep(1);
  }
