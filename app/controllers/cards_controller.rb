class CardsController < ApplicationController
  skip_forgery_protection

  # POST /cards
  def create
    @image = Image.new(card_params)

    if @image.save
      render json: { url: card_url(@image, format: :svg) }
    else
      render json: { error: 'Image creation failed.', status: 400 }, status: :bad_request
    end
  end

  # GET /card/Z7j0940LYUrV6SRcWyra6g
  def show
    @image = Image.find_by!(key: params[:id])

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
