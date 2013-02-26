
class OverviewHookListener < Redmine::Hook::ViewListener
	def controller_issues_edit_after_save(context={} )
		#context[:issue].subject = "Nothing to fix" 
	end
  #issues = Issue.find_all_by_project_id(params[:project_id])
  def view_projects_show_left(context={} )
    #return content_tag("p", context[:project].name)
  end
  def view_projects_show_right(context={} )
	issues = Issue.find(:all, :conditions => {:project_id => context[:project].id})
    my_html = content_tag("p","Top 5 rick issues")
	issues.each { |iss|
		my_html += content_tag("p", iss)
	}
	#content_tag("p", issues[0])+content_tag("p", issues[1])
	return my_html
  end
end