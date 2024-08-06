● Создайте манифест, описывающий pod с distroless образом для создания контейнера, например kyos0109/nginx-distroless и примените его в кластере.
```
kubectl create namespace homework
kubectl config set-context --current --namespace=homework
kubectl apply -f config-map.yaml
kubectl apply -f distroless-pod.yaml
```

● С помощью команды kubectl debug создайте эфемерный контейнер для отладки этого пода. Отладочный контейнер должен иметь доступ к пространству имен pid для основного контейнера пода.
```
kubectl debug -it distroless-pod --image=busybox --target=nginx --share-processes
```

● Получите доступ к файловой системе отлаживаемого контейнера из эфемерного. Приложите к результатам ДЗ вывод команды ls –la для директории /etc/nginx
```
kubectl debug -it distroless-pod --image=busybox --target=nginx --share-processes
Targeting container "nginx". If you don't see processes from this container it may be because the container runtime doesn't support this feature.
Defaulting debug container name to debugger-5xb4f.
If you don't see a command prompt, try pressing enter.
/ # 
/ # ls -la /proc/1/root/etc/nginx/
total 48
drwxr-xr-x    3 root     root          4096 Oct  5  2020 .
drwxr-xr-x    1 root     root          4096 Aug  2 06:52 ..
drwxr-xr-x    2 root     root          4096 Oct  5  2020 conf.d
-rw-r--r--    1 root     root          1007 Apr 21  2020 fastcgi_params
-rw-r--r--    1 root     root          2837 Apr 21  2020 koi-utf
-rw-r--r--    1 root     root          2223 Apr 21  2020 koi-win
-rw-r--r--    1 root     root          5231 Apr 21  2020 mime.types
lrwxrwxrwx    1 root     root            22 Apr 21  2020 modules -> /usr/lib/nginx/modules
-rw-r--r--    1 root     101            636 Aug  2 06:52 nginx.conf
-rw-r--r--    1 root     root           636 Apr 21  2020 scgi_params
-rw-r--r--    1 root     root           664 Apr 21  2020 uwsgi_params
-rw-r--r--    1 root     root          3610 Apr 21  2020 win-utf
```

● Запустите в отладочном контейнере команду tcpdump -nn -i any -e port 80 (или другой порт, если у вас приложение на нем)
● Выполните несколько сетевых обращений к nginx в отлаживаемом поде любым удобным вам способом. Убедитесь что tcpdump отображает сетевые пакеты этих подклячений. Приложите результат работы tcpdump к результатам ДЗ.
```
bokhanych@cl1o5nsr90j5ae2j79hh-egaz:~$ curl 10.245.129.11
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
```
kubectl debug -it distroless-pod --image=itsthenetwork/alpine-tcpdump --target=nginx --share-processes -- tcpdump -nn -i any -e port 80

Targeting container "nginx". If you don't see processes from this container it may be because the container runtime doesn't support this feature.
Defaulting debug container name to debugger-qbwpd.
If you don't see a command prompt, try pressing enter.
07:23:40.463112  In 06:8a:d9:17:0d:b3 ethertype IPv4 (0x0800), length 76: 10.131.0.10.51506 > 10.245.129.11.80: Flags [S], seq 3434353912, win 64240, options [mss 1460,sackOK,TS val 1578161049 ecr 0,nop,wscale 7], length 0
07:23:40.463164 Out d6:32:2a:d3:2f:45 ethertype IPv4 (0x0800), length 76: 10.245.129.11.80 > 10.131.0.10.51506: Flags [S.], seq 273086888, ack 3434353913, win 65160, options [mss 1460,sackOK,TS val 1952184308 ecr 1578161049,nop,wscale 7], length 0
07:23:40.463345  In 06:8a:d9:17:0d:b3 ethertype IPv4 (0x0800), length 68: 10.131.0.10.51506 > 10.245.129.11.80: Flags [.], ack 1, win 502, options [nop,nop,TS val 1578161050 ecr 1952184308], length 0
```

● С помощью kubectl debug создайте отладочный под для ноды, на которой запущен ваш под с distroless nginx
```
kubectl debug node/cl1o5nsr90j5ae2j79hh-ywyc --image=busybox -ti
Creating debugging pod node-debugger-cl1o5nsr90j5ae2j79hh-ywyc-vtzfv with container debugger on node cl1o5nsr90j5ae2j79hh-ywyc.
If you don't see a command prompt, try pressing enter.
/ # 
```

● Получите доступ к файловой системе ноды, и затем доступ к логам пода с distrolles nginx. Приложите сами логи, и команду их получения к результатам ДЗ. 
```
/ # tail -n 20 /host/var/log/pods/homework_distroless-pod_ceb70e08-8a3f-4bd3-9cb6-ba93062ee08f/nginx/0.log 
2024-08-02T07:15:25.599169498Z stdout F 10.131.0.10 - - [02/Aug/2024:15:15:25 +0800] "GET / HTTP/1.1" 200 612 "-" "curl/7.68.0" "-"
2024-08-02T07:19:20.295707058Z stdout F 10.131.0.10 - - [02/Aug/2024:15:19:20 +0800] "GET / HTTP/1.1" 200 612 "-" "curl/7.68.0" "-"
2024-08-02T07:23:40.463821072Z stdout F 10.131.0.10 - - [02/Aug/2024:15:23:40 +0800] "GET / HTTP/1.1" 200 612 "-" "curl/7.68.0" "-"
```
