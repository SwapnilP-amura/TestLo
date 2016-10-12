class TestsController < ApplicationController
    before_action :check_user ,except:[:result]    #for all actions
    before_action :check_employer_profile, only: [:create, :new]
    before_action :get_test_by_id ,only:[:destroy,:activate,:privacy,:show,:result]
    before_action :get_test_by_test_id,only:[:add_question_to_current_test,:remove_question_from_current_test]
    before_action :check_test_owner,only:[:destroy,:activate,:privacy,:add_question_to_current_test,:remove_question_from_current_test]
    before_action :check_test_active,only:[:add_question_to_current_test,:remove_question_from_current_test,:destroy]

    def index
        @tests = Test.all
    end

    def new
        # check_employer_profile filter
        @test = Test.new
    end

    def create
      @test = current_user.tests.build(test_params)
        if @test.save
            flash[:success] = 'Test created Successfully'
            redirect_to test_path(@test)
        else
            render 'new'
        end
    end

    def destroy
        #get_test_by_id
        #check_test_owner
        #check_test_active
        if @test.destroy
          flash[:success] = 'Deleted Successfully'
          redirect_to employer_dashboard_path
        end
    end

    def activate
        #get_test_by_id
        #check_test_owner
        if @test.active
            activate_and_flash
        else
          if @test.marks > 10
            activate_and_flash
          else
            flash[:danger] = 'Minimum marks for test is 10'
          end
        end
        redirect_to test_path(@test)
    end

    def privacy
        #get_test_by_id
        #check_test_owner
        if @test.change_privacy
          flash[:success] ="This test is #{@test.private? ? 'Private' : 'Public'} now"
          redirect_to test_path(@test)
        else
          flash[:danger] = 'Unable to change privacy,Try later'
          redirect_to test_path(@test)
        end
    end

    def add_question_to_current_test
        #filter-get_test_by_test_id
        #filter-check_test_owner
        #filter-check_if_active
        TestQuestion.create_test_question(@test.id,params[:question_id],params[:marks])
        #view logic
        join_data
        # redirect_to test_path(@test) (if not using ajax)
        respond_to do |format|
            format.js
        end
    end

    def remove_question_from_current_test
        #filter-get_test_by_test_id
        #filter-check_test_owner
        #filter-check_if_active
        TestQuestion.remove_test_question(@test.id,params[:question_id])
        # view logic
        join_data
        respond_to do |format|
            format.js
        end
    end

    def show
        #get_test_by_id
        #check_test_owner
        join_data
    end

    def result
        #filter-get_test_by_id
        @result=Enrollment.get_results_of_test(@test)
    end

    private

    def test_params
        params.require(:test).permit(:name, :date, :duration)
    end

    def activate_and_flash
      #toggles test activation and displays appropriate flash
      if @test.change_activity
          flash[:success] = "Test is #{@test.active? ? 'Active' : 'Inactive'} now"
      else
          flash[:danger] = 'Unable to deactivate,Try later'
      end
    end
    # Filters

    def check_user
        unless current_user.type=="Employer"
          flash[:danger]="Authorizaion Error"
          redirect_to error_path
        end
    end

    def check_employer_profile
        if current_user.employer_detail.nil?
          flash[:danger] = 'Complete profile first'
          redirect_to new_employer_details_path
        end
    end

    def get_test_by_id
      @test=Test.get_test_by_id(params[:id])
    end

    def get_test_by_test_id
      @test=Test.get_test_by_id(params[:test_id])
    end

    def check_test_owner
      unless @test.employer_id==current_user.id
        flash[:danger]="You are not owner of this test"
        redirect_to employer_dashboard_path
      end
    end

    def check_test_active
      if @test.active
          flash[:danger] = 'Deactivate test first'
          return redirect_to test_path(@test)
      end
    end

    def join_data
      #left partial
      @test_questions=TestQuestion.get_questions_of_test(@test)
      #right partial
      @questions=Question.get_questions_excluding(@test_questions.map{|t| t.question.id})
    end
end
