class PagesController < ApplicationController

  before_filter RubyCAS::Filter, except: [:invaliduser] do |controller|
      controller.valid_user()
  end

  before_action :check_settings

  def home
  end

  def invaliduser
  end

end
