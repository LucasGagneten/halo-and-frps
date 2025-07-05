# hf
halo and frps
Halo + FRPS Docker部署指南
部署步骤
在render.com创建Web Service
连接GitHub仓库并选择分支
环境变量配置：
   FRPSTOKEN: FRPS服务认证令牌
   FRPSDASH_PWD: Dashboard访问密码
端口映射：
   Halo: 8090 -> 80
   FRPS: 7000/7500
启动服务
访问方式
Halo博客: http://
FRPS Dashboard: http://:7500
