module ApplicationHelper

  def devise_mapping
   @devise_mapping ||= Devise.mappings[:user]
  end

  # フラッシュメッセージのタイプごとにbootstrapのカラーを指定する。
  def bootstrap_class_for_flash(flash_type)
    case flash_type.to_sym
    when :success
      "success"
    when :error
      "danger"
    when :alert
      "warning"
    when :notice
      "info"
    else
      flash_type.to_s
    end
  end
end
