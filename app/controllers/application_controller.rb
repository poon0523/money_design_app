class ApplicationController < ActionController::Base
    include HouseholdsHelper
    before_action :configure_permitted_parameters, if: :devise_controller?
    rescue_from Exception,                      with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404


    # deviseのビルドインメソッドを通して、ログイン後の遷移先を指定
    def after_sign_in_path_for(resource)
        # ログイン後は「家計状況一覧」に遷移する
        households_path
    end

    # 管理者権限（admin）がない場合に管理者用画面（rails-admin）にアクセスしようとした場合に、ログインユーザーの家計状況一覧に遷移させる処理
    rescue_from CanCan::AccessDenied do |exception|
        respond_to do |format|
          format.json { head :forbidden }
          format.html { redirect_to main_app.households_path, alert: "管理者権限がないのでアクセスできません" }
        end
    end
    
    # アプリの各種アクションを実行する、どのルーティングにも当てはまらない場合にルーティングエラーを明示的に発生させる処理
    # ※明示的にエラーを発生させることでrescue_from ActionController::RoutingError, with: :_render_404の処理を実行させる
    def routing_error
        raise ActionController::RoutingError, params[:path]
    end
    
    
    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :admin, :age, :marital_status, :spouse_age, :children_number])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :admin, :age, :marital_status, :spouse_age, :children_number])
    end

    private

    # RecordNotFound／RoutingErrorが発生した際にrescue_fromで呼び出される処理
    def _render_404(error = nil)
        # エラー詳細をログに記録
        logger.info "Rendering 404 with excaption: #{error.message}" if error

        respond_to do |format|
            format.json { render json: { error: "404 Not Found" }, status: :not_found }
            format.all { render 'errors/404.html.erb', content_type: 'text/html', status: :not_found, layout: 'error' }
        end
    end

    # Exceptionが発生した際にrescue_fromで呼び出される処理  
    def _render_500(error = nil)
        # エラー詳細をログに記録
        logger.error "Rendering 500 with excaption: #{error.message}" if error

        respond_to do |format|
            format.json { render json: { error: "500 Internal Server Error" }, status: :internal_server_error }
            format.all { render 'errors/500.html.erb', content_type: 'text/html', status: :internal_server_error, layout: 'error' }
        end
    end  

end
