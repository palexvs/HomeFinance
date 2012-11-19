class CategoriesController < ApplicationController
  include TheSortableTreeController::Rebuild
  
  before_filter :loged_in
  before_filter :get_category_by_id, only: [:edit, :show, :update, :destroy]

  respond_to :json, :html

  def index
    @categories_outlay = current_user.categories.where("type_id = ?",0).nested_set.all
    @categories_income = current_user.categories.where("type_id = ?",1).nested_set.all

    respond_with do |format|
      format.html { render :index }
    end
  end

  def new
    @category = Category.new :type_id => Transaction::TYPES.index(params[:type]) || Transaction::TYPES.index('outlay')

    respond_with(@category, :location => categories_path)
  end  

  def edit
  end

  def create
    @category = current_user.categories.build(params[:category])

    flash[:notice] = 'Account was successfully created.' if @category.save

    respond_with(@category, :location => categories_path)
  end

  def update
    flash[:notice] = 'Account was successfully updated.' if @category.update_attributes(params[:category])

    respond_with(@category, :location => categories_path)
  end

  def destroy
    flash[:notice] = 'Account was successfully deleted.' if @category.destroy

    respond_with(@category)
  end

  private

  def get_category_by_id
    @category = current_user.categories.find_by_id(params[:id])

    if @category.nil?
      redirect_to categories_path, alert: "Can't get such category."
    end
  end

end