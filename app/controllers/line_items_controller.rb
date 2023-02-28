class LineItemsController < ApplicationController
  before_action :set_line_item, only: %i[ show edit update destroy ]
  before_action :authenticate_admin, only: %i[index show]

  # GET /line_items or /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1 or /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items or /line_items.json
  def create

    if(user_signed_in?)

      puts current_user
      @line_item = LineItem.where(store_id: params[:store_id]).find_by_user_id(current_user)
      puts @line_item
      if(@line_item.nil?)
        params[:qty] = 1
        @line_item = LineItem.new(store_id:params[:store_id], user_id:current_user.id, qty:params[:qty])
        respond_to do |format|
          if @line_item.save
            format.html { redirect_to '/cart/index', notice: "Line item was successfully created." }
            format.json { render :show, status: :created, location: @line_item }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @line_item.errors, status: :unprocessable_entity }
          end
        end
      else
        params[:qty] = @line_item.qty + 1
        update
      end
    else
      flash[:notice] = "Please login to continue."
      render '/pages/index.html'
    end
  end

  # PATCH/PUT /line_items/1 or /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(store_id:params[:store_id], user_id:current_user.id, qty:params[:qty])
        format.html { redirect_to 'cart/index', notice: "Line item was successfully updated." }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to '/cart/index', notice: "Line item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.require(:line_item).permit(:store_id, :user_id, :qty)
    end

    def authenticate_admin
      if(!session[:admin])
        redirect_to "/admin/login"
        return
      end
    end
end
