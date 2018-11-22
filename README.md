# Apache server-status-monitor
Script escrito em perl com a finalidade de monitorar o server-status do apache num log.
Este script pode ser adicionado na crontab para que seja executado rotineiramente, assim gerando um arquivo de log no caminho: /opt/web/output/.

 Usar o script do conforme abaixo

      ./coleta_serverstatus.pl <Ip do Servidor Apache> <porta> <hostname>
 
 Obs: No "Ip do Servidor Apache", também pode ser um nome que resolva o destino.

O parâmetro de "hostname" vai ser o nome que ele ira gerar o output da saída no caminho: /opt/web/output/

Exemplo de execução:

./coleta_serverstatus.pl localhost 80 localhost

Exemplo de saída:

cat /opt/web/output/localhost.txt

2018/11/21 09:58:31 Server_Uptime:13 days 10 hours 1 minute 8 seconds Total_accesses:388428743 Total_Traffic:6119.0 GB CPU_Load:1.81% requests/sec:335 MB/second:5.4 kB/request:16.5 Requests:1557 Idle_Workers:1515






