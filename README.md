## Configuration options

| with 参数  | 是否必填 | 默认值      | 字段描述                                                                                                                                              |
| ---------- | -------- | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| `user`     | 是       | `root`      | 登录远程服务器的用户名.                                                                                                                               |
| `host`     | 是       | `localhost` | 远程服务器的 ip 地址.                                                                                                                                 |
| `port`     | 否       | `22`        | 远程服务器的端口.                                                                                                                                     |     |
| `password` | 否       |             | 登录远程服务器的密码.                                                                                                                                 |
| `scp_key`  | 是       |             | 公钥，从服务器 ~/.ssh/id_rsa 文件获取，需要添加到 github 项目的 Secrets.                                                                              |
| `source`   | 是       |             | 上传的目录或文件.                                                                                                                                     |
| `target`   | 是       |             | 服务器对应的项目目录.                                                                                                                                 |
| `exclude`  | 否       |             | 上传的目录中需要排除的文件或子目录.                                                                                                                   |
| `command`  | 否       |             | 服务器终端命令行：当部署的项目为 node 项目时，可能需要一些后续操作，比如需要在服务器上启动项目，使用 pm2 开启进程守护等等操作，可以自行进行后续等操作 |

## Recommended action configuration

使用示例（例如：.github/workflows/deploy.yml）

```yaml
name: deploy

on:
  push:
    branches: [master]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: 📥 Checkout the repository
        uses: actions/checkout@v2

      - name: 📤 Upload files to the server and connect to the remote server
        uses: nuonuonuonuoyan/auto-deploy@v1
        with:
          user: ${{ secrets.USER }}
          host: ${{ secrets.HOST }}
          key: ${{ secrets.KEY }}
          scp_key: ${{ secrets.SCP_KEY }}
          source: '/'
          target: '/home/tests'
          password: ${{ secrets.PASSWORD }}
          command: |
            cd /home/tests
            git pull
            echo `ls -a`
```
