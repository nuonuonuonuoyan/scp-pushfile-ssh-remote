echo "# scp-pushfile-ssh-remote" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:nuonuonuonuoyan/scp-pushfile-ssh-remote.git
git push -u origin main
