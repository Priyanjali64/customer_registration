class CustomersController < ApplicationController
  before_action :set_customer, only: :destroy

  def index
    @customers = Customer.order(created_at: :desc)
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to customers_path, notice: "Customer registered successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy

    redirect_to customers_path, notice: "Customer deleted successfully."
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(
      :full_name, :id_number, :date_of_birth,
      :address, :phone, :id_document
    )
  end
end
