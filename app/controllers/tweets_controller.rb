class TweetsController < ApplicationController

    get '/tweets' do
        if logged_in?
            @user = current_user
            @tweets = Tweet.all
            erb :'/tweets/index'
        else
            redirect '/login'
        end
    end

    get '/tweets/new' do
        if logged_in? 
            @user = current_user
            erb :'tweets/new'
        else
            redirect to '/login'
        end
    end

    post '/tweets' do
        t = Tweet.new(params)
        if !t.save
            redirect to "/tweets/new"
        else
            current_user.tweets << t
            current_user.save
            redirect '/tweets'
        end
    end

    get '/tweets/:id' do
        if logged_in?
          @user = current_user
          @tweet = Tweet.find_by_id(params[:id])
          erb :'tweets/show'
        else
          redirect to '/login'
        end
    end

    get '/tweets/:id/edit' do
        @tweet = Tweet.find_by_id(params[:id])
        if logged_in? && @tweet.user == current_user
          erb :'/tweets/edit'
        else
          redirect 'login'
        end
    end

    patch '/tweets/:id' do
        tweet = Tweet.find_by_id(params[:id])
        if params[:content].blank?
            redirect "tweets/#{params[:id]}/edit"
        else
            tweet.update(:content => params[:content])
            tweet.save
            redirect "tweets/#{params[:id]}"
        end
    end

    delete '/tweets/:id' do
        tweet = Tweet.find_by_id(params[:id])
        if current_user == tweet.user
            tweet.delete
            redirect to '/tweets'
          else
            redirect to "/tweets/#{params[:id]}"
          end
    end

end