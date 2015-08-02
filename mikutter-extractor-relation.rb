#coding: utf-8

Plugin.create(:"mikutter-extractor-relation") {
  def check_proc(message, target_set)
    begin
      result = Service.any? { |me|
        if target_set[me.user_obj]
          target_set[me.user_obj].any? { |you| you == message.user }
        else
          false
        end
      }

      # フォローとかされてて、システムメッセージでない(@mikutter_bot対策)
      result && !message.system?
    rescue => e
      puts e
      puts e.backtrace
    end
  end

  # フォローしている
  defextractcondition(:followings, name: _("フォローしている"), operator: false, args: 0) { |message: raise|
    check_proc(message, Plugin[:followingcontrol].relation.followings)
  }

  # フォローされている
  defextractcondition(:followers, name: _("フォローされている"), operator: false, args: 0) { |message: raise|
    check_proc(message, Plugin[:followingcontrol].relation.followers)
  }
}
