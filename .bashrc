source api_tokens_for_travis.sh
echo 'to test: ruby -I./lib test.rb'
echo 'or: ruby -I../nethttputils/lib -I./lib ./bin/directlink --debug ...'
echo 'or: bundle exec ruby -I./lib ./bin/directlink --debug ...'
echo 'or: byebug -I./lib ./bin/directlink ...'
