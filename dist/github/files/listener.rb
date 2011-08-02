#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

class Listener < Sinatra::Base
  def verbose msg
    $stderr.puts msg if settings.verbose
  end

  post '/update/:user/:repo' do
    status = 404
    allowed = []

    # Parse out repositories we're allowed to update from github
    # Format is "user/repo, url", where user/repo reflects the github path
    # and url is the associated address to fetch
    begin
      File.open("#{settings.basedir}/.github-allowed") do |file|
        file.each do |line|
          allowed << line.chomp!
        end
      end
    rescue => e
      verbose "Error reading allowed github repos: #{e.backtrace.join('\n')}"
      halt 403
    end

    repo_path = "#{settings.basedir}/#{params[:user]}-#{params[:repo]}.git"
    identifier = "#{params[:user]}/#{params[:repo]}"
    if File.directory? repo_path
      if allowed.include? identifier

        # If the requested directory exists and is allowed, pull it.
        # Otherwise, log to stderr/apache error.log why things failed
        # and 404
        cmd = %Q{git --git-dir #{repo_path} fetch --all --verbose --prune}
        verbose %Q{Updating repo #{identifier} with command "#{cmd}"}
        %x{#{cmd}}
        status = 200
      else
        verbose "Disallowed repo #{repo_path}"
      end
    else
      verbose "Nonexistent repo #{repo_path}"
    end

    status
  end

  not_found do
    404
  end
end
