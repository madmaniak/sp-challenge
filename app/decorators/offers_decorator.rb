class OffersDecorator < ApplicationDecorator

  def all
    offers || []
  end

  def fine?
    ['OK', 'NO_CONTENT'].include? code
  end

  def no?
    code == 'NO_CONTENT'
  end

end
