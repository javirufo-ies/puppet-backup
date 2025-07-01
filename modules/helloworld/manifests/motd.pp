 class helloworld::motd {
   file { 'c:/motd':
   content => "hello, world!\n",
   }
 }
