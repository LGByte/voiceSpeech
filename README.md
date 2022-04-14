# voiceSpeech
IOS 语音播报 


cd 指定目录
ssh-keygen -t rsa -b 1024 -f 名字  -C "备注"
到根目录 .ssh
创建config文件
# GitLab.com
Host gitlab.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/gitlab_com_rsa

# host
Host 192.168.**.251
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa
# host
Host github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/gitHubKey
# host
Host give.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/giteekey
