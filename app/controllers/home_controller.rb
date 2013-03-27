class HomeController < ApplicationController
  def index
    client = Octokit::Client.new(:login => ENV['github_username'], :password => ENV['github_password'])
    @github_repos = client.repositories('phatograph', :type => 'owner')
    # @github_repos = []

    bitbucket = BitBucket.new :login => ENV['bitbucket_username'], :password => ENV['bitbucket_password']
    @bitbucket_repos = bitbucket.repos.list
    # @bitbucket_repos = []

    heroku = Heroku::API.new(:username => ENV['heroku_username'], :password => ENV['heroku_password'])
    @heroku_apps = heroku.get_apps.body
  end
end
