class Employer::DetailsController < ApplicationController

  def edit
      @employer=Employer.find(current_user.id)
      @employer_detail=@employer.employer_detail
  end

  def new
      @employer=Employer.find(current_user.id)
      @employer_detail=@employer.build_employer_detail
  end

  def create
      @employer=Employer.find(current_user.id)
      @detail=@employer.build_employer_detail(employer_details_params)
      if @detail.save
        flash[:success]="Profile Created Successfully"
        redirect_to employer_dashboard_path
      else
        render 'new'
      end
  end

  def update
    @employer=Employer.find(current_user.id)
    if @employer.employer_detail.update_attributes(employer_details_params)
      flash[:success]="Profile Updated Successfully"
      redirect_to employer_dashboard_path
    else
      render 'edit'
    end
  end

  private
    def employer_details_params
      params.require(:employer_detail).permit(:company,:company_address,:contact)
    end
end
