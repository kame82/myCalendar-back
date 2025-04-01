class ApplicationController < ActionController::API
  include ActionController::Cookies

  def health_check
    render json: { message: 'Hello World' }
    puts 'Hello World'
  end

end
