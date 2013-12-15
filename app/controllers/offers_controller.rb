class OffersController < ApplicationController

  expose(:offers) { OffersDecorator.new Offers.new( offers_params ).get }

  private

  def offers_params
    params.permit :uid, :pub0, :page
  end

end
