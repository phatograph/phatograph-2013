class Exits
  extend Garb::Model

  metrics :visitors
  dimensions :visit_count
end

class HomeController < ApplicationController
  def index
    @github_repos    = Project.where(:provider => 'github')
    @bitbucket_repos = Project.where(:provider => 'bitbucket')
    @heroku_apps     = Project.where(:provider => 'heroku')
  end

  def fetch
    github = Octokit::Client.new(:login => ENV['github_username'], :password => ENV['github_password'])
    github.repositories('phatograph', :type => 'owner').each do |repo|
      Project.where({
        :name => repo[:name],
        :provider => 'github'
      }).first_or_create!(:size => repo[:size])
    end

    bitbucket = BitBucket.new :login => ENV['bitbucket_username'], :password => ENV['bitbucket_password']
    bitbucket.repos.list.each do |repo|
      Project.where({
        :name => repo[:name],
        :provider => 'bitbucket'
      }).first_or_create!(:size => repo[:size] / 1.kilobyte)
    end

    heroku = Heroku::API.new(:username => ENV['heroku_username'], :password => ENV['heroku_password'])
    heroku.get_apps.body.each do |repo|
      Project.where({
        :name => repo['name'],
        :provider => 'heroku'
      }).first_or_create!(:size => repo['repo_size'] / 1.kilobyte)
    end

    render :text => '200'
  end

  def ga
    Garb::Session.login(ENV['google_username'], ENV['google_password'])

    profiles = Garb::Management::Profile.all
    profiles.each do |p|
      result = Exits.results(p, {
        :start_date => Date.today - 1,
        :end_date => Date.today
      })

      puts p.web_property_id
      puts result.count
    end

    render :text => '200'
  end
end
