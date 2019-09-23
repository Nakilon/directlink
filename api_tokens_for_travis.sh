export IMGUR_CLIENT_ID=0f99cd781c9d0d8
export FLICKR_API_KEY=dc2bfd348b01bdc5b09d36876dc38f3d
export REDDIT_SECRETS=reddit_token_for_travis.yaml

touch vk.secret
source vk.secret
# export VK_ACCESS_TOKEN=...                  # can't put this here because there is no way known to me to limit the scope of the eternal access token
# export VK_CLIENT_SECRET=... # (service key) # can't put this here because there is no way known to me to limit the scope of the eternal access token
