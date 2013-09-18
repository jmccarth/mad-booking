class PagesController < ApplicationController
  
  before_filter RubyCAS::Filter, except: [:invaliduser] do |controller|
      controller.valid_user()
  end
  
  def home
  end

  def invaliduser
  end
end