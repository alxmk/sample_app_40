class UsersController < ApplicationController
	before_action :signed_in_user, 				only: [:index, :edit, :update, :destroy]
	before_action :correct_user,	 				only: [:edit, :update]
	before_action :admin_user,		 				only: :destroy
	before_action :prevent_double_signup,	only: [:new, :create]

  def new
  	@user = User.new
  end
  
  def show
  	@user = User.find(params[:id])
  	@microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def create
  	@user = User.new(user_params)
  	if @user.save
  		sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end
  
  def edit
  end
  
  def update
  	if @user.update_attributes(user_params)
  		flash[:success] = "Profile updated"
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end
  
  def index
  	@users = User.paginate(page: params[:page])
  end
  
  def destroy
  	@user.destroy
  	flash[:success] = "User deleted."
  	redirect_to users_url
  end
  
  private
  
  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end
  	
  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to root_url unless current_user?(@user)
  	end
  	
  	def admin_user
  		@user = User.find(params[:id])
  		if current_user.admin?
  			if current_user?(@user)
  				flash[:error] = "You can't delete yourself!"
  				redirect_to users_url
  			end
  		else
  			redirect_to root_url
  		end
  	end
  	
  	def prevent_double_signup
  		if signed_in?
  			redirect_to root_url
  		end
  	end
  	  	
end
