#!/usr/bin/perl
#
# Script para coleta de metricas do Server Status do Apache
#
#
################################################################

#use warnings;
#use strict;
use IO::Handle;
use IO::Socket;
use File::Basename;
use File::Path;

############
# Variaveis
my ($url,$line,$aux,$uptime,$total_access,$total_traffic,$request_sec,$mb_sec,$kb_sec,$request_cur,$idle_works);
my %count_line;
my $i=0;

my $host = $ARGV[0];
my $port = $ARGV[1];
my $server= $ARGV[2];
my $output = "/opt/web/output/";

my $scriptname = basename($0);



if ( defined($host) && defined($port) && defined($server) ) { 

} else {

print "\n";
print "   Usar o script do conforme abaixo\n";
print "\n";
print "      ./" . $scriptname . " <Ip do Servidor Apache> <porta> <hostname>\n";
print "\n";
print "\n";
print "    Ex.:\n";
print "\n";
print "          ./" . $scriptname . " 10.128.153.69 8080 jardimtropical  \n";
print "\n";

exit 1;

};


#Format local time
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time());
$year += 1900; $mon += 1; if($sec <10){$sec="0".$sec}; if($min<10){$min="0".$min};

if($hour<10){$hour="0".$hour}; if($mon<10){$mon="0".$mon}; if($mday<10){$mday="0".$mday};
   my $hora = $year . "/" . $mon . "/" . $mday . " " . "$hour:$min:$sec";
   my $log_date = $year . "-" . $mon . "-" . $mday;


#######################################################
# Verificando se existe outro processo do script no ar

#my $ps_command = "ps auxw";
#my $count;
# 
#open(PS,"$ps_command 2>/dev/null |") || "Failed: $!\n";
#  while ( $line = <PS> ) {
#    chomp($line);
#    if ($line =~ m/\/usr\/bin\/perl.*$scriptname/) {
#	$count += 1;
#    };
#  };
#
#  if ( $count > 1 ) {
#        print "\n\nOutro proceso ".$scriptname." esta rodando, Abortando a execucao....\n\n";
#        exit 1;
#   };
#
#close(PS);

#################
# Coleta via Curl

open (RESULTADO, ">>" . $output . $server . ".txt" );


my $curl_command = "curl -s http://" . $host . ":" . $port . "/server-status | egrep ^'<dt>'";

open(CURL,"$curl_command 2>/dev/null |") || "Failed: $!\n";
  while ( $line = <CURL> ) {
    chomp($line);


    #<dt>Server uptime:  17 hours 48 minutes 7 seconds</dt>
    if($line =~ /.*\<dt\>Server uptime\:\s+(\d+.*)\<\/dt>.*/){
       $uptime= $1;
       next;
    };


    #<dt>Total accesses: 45711630 - Total Traffic: 524.6 GB</dt>
    if($line =~ /.*\<dt\>Total accesses\:\s+(\d+)\s+\-\sTotal\sTraffic\:\s(\d+.*)\<\/dt>.*/){
	$total_access = $1;
	$total_traffic = $2; 
        next;
    };


    #<dt>CPU Usage: u9361.27 s2243.85 cu0 cs0 - 18.1% CPU load</dt>
    if($line =~ /.*\<dt\>CPU\s+Usage:.*\s+\-\s+(.*)\%\s+CPU\s+load\<\/dt>.*/){
	$cpu_load = $1;
    };


    #<dt>713 requests/sec - 8.4 MB/second - 12.0 kB/request</dt>
    if($line =~ /.*\<dt\>(.*)\s+requests\/sec\s+\-\s+(.*)\sMB\/second\s+\-\s+(.*)\skB\/request\<\/dt>.*/){
	$request_sec = $1;
	$mb_sec = $2;
	$kb_sec = $3;
        next;
    };


    #<dt>3333 requests currently being processed, 763 idle workers</dt>
    if($line =~ /.*\<dt\>(\d+)\s+requests\s+currently\s+being\s+processed\,\s+(\d+)\s+idle\s+workers\<\/dt>.*/){
	$request_cur = $1;
	$idle_works = $2;
    };



   };


    print RESULTADO  $hora . " Server_Uptime:" . $uptime . " Total_accesses:" . $total_access . " Total_Traffic:" . $total_traffic  . " CPU_Load:" . $cpu_load ."% requests/sec:" . $request_sec  .  " MB/second:" . $mb_sec . " kB/request:" . $kb_sec  . " Requests:" . $request_cur . " Idle_Workers:" . $idle_works ."\n";


close(CURL);

close(RESULTADO);
