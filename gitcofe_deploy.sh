rake generate
rake deploy

cd _deploy
# ��� gitcafe Դ
git remote add gitcafe git@gitcafe.com:i4box/i4box.git >> /dev/null 2>&1
# �ύ��������
echo "### Pushing to GitCafe..."
git push -u gitcafe master:gitcafe-pages
echo "### Done"%
