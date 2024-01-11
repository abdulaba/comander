class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end
  def edit

  @table = Table.find(params[:table_id])
  @orders = @table.orders.includes(:foods)
  @waiter = @orders.first.waiter
  end

  def new
    @table = Table.find(params[:table_id])
    @order = Order.new
    @foods = Food.where(type: 'dish')
    @drinks = Food.where(type: 'drink')
    @waiter = Waiter.all
    @kitchen = Kitchen.first
  end

  def create
    @foods = Food.all
    @table = Table.find(params[:table_id])
    @order = Order.create(order_params)
    @order.kitchen_id = 1
    @order.table_id = @table.id
    if @order.save
      foods = params[:foods]
      foods.each do |food|
        SelectedFood.create(order: @order, food_id: food)
      end
      redirect_to tables_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:waiter_id)
  end
end
