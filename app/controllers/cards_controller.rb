class CardsController < ApplicationController
  skip_forgery_protection

  # POST /cards
  def create
    @card = Card.new(card_params)

    if @card.save
      render json: { url: card_url(@card, format: :svg) }
    else
      render json: { error: 'Card creation failed.', status: 400 }, status: :bad_request
    end
  end

  # GET /card/Z7j0940LYUrV6SRcWyra6g
  def show
    @card = Card.find_by!(key: params[:id])

    respond_to do |format|
      format.svg {  render content_type: 'image/svg+xml' }
      format.html
    end
  end

  private

  def card_params
    params.require(:card).permit(:name, :headshot)
  end
end
