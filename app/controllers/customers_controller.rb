class CustomersController < ApplicationController
  def index
    @customers = Customer.all
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
    @customer = Customer.find(params[:id])
    @customer.destroy

    redirect_to customers_path, notice: "Customer deleted successfully."
  end

  private

  def customer_params
    params.require(:customer).permit(
      :full_name, :id_number, :date_of_birth,
      :address, :phone, :id_document
    )
  end
end
