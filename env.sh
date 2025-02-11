git config --global user.email "$GIT_EMAIL" && \
git config --global user.name "$GIT_USER" && \
git config --global credential.helper 'store' && \
echo "https://${GIT_USER}:${GIT_PASSWORD}@github.com" > ~/.git-credentials && \
git config --global core.autocrlf false