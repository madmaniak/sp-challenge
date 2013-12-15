class OffersController < ApplicationController

  expose(:offers) { OffersDecorator.new Offers.new( offers_params ).get }

  before_filter :set_flash, only: :index

  private

  def offers_params
    params.permit :uid, :pub0, :page
  end
  
  def set_flash
    if offers.message.present?
      type = offers.fine? ? :success : :alert
      flash.now[type] = offers.message
    end
  end

end
