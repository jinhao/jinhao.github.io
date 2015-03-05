# error: zsh: no matches found: new_post[TCP重传相关几个参数]
# alias rake='noglob rake'


rake generate
rake deploy

cd _deploy
# 添加 gitcafe 源
git remote add gitcafe git@gitcafe.com:i4box/i4box.git >> /dev/null 2>&1
# 提交博客内容
echo "### Pushing to GitCafe..."
git push -u gitcafe master:gitcafe-pages
echo "### Done"%
