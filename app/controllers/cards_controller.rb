class CardsController < ApplicationController
  skip_forgery_protection

  # POST /cards
  def create
    @card = Card.new(card_params)

    if @card.save
      render json: {
        card: card.to_json,
        urls: {
          png: card_url(@card, format: :png, protocol: :https),
          html: card_url(@card, format: :html, protocol: :https),
          svg: card_url(@card, format: :svg, protocol: :https)
        }
      }
    else
      render json: { error: 'Card creation failed.', status: 400 }, status: :bad_request
    end
  end

  # GET /card/Z7j0940LYUrV6SRcWyra6g
  def show
    @card = Card.find_by!(key: params[:id])

    respond_to do |format|
      format.svg {  render content_type: 'image/svg+xml' }
      format.png do
        imagedata = ApplicationController.render(template: 'cards/show', formats: [:svg], assigns: { card: @card })
        self.instance_variable_set(:@_response_body, nil)
        image = MiniMagick::Image.read(imagedata)
        im = MiniMagick::Tool::Convert.new do |convert|
          convert << image.path
          convert.format("png")
          convert.resize("600")
          convert << "-"
        end
        render plain: im.to_blob, content_type: 'image/png'
      end
      format.html
    end
  end

  private

  def card_params
    params.require(:card).permit(:name, :headshot, :address, :phone,
                                :slogan, :member_of, :color)
  end
end
