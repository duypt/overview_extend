
class OverviewHookListener < Redmine::Hook::ViewListener
	def controller_issues_edit_after_save(context={} )
		#context[:issue].subject = "Nothing to fix" 
	end
  #issues = Issue.find_all_by_project_id(params[:project_id])
  #def view_projects_show_left(context={} )
    #return content_tag("p", context[:project].name)
  #end
  def view_projects_show_left(context={} )
  	# get all issues with project_id condition
	issues = Issue.find(:all, :conditions => {:project_id => context[:project].id})
    # title tag
    my_title_html = content_tag("h3","Top 5 risk issues")
	# table header
	id_header_tag = content_tag("a","#",:class => "sort desc", :href => "/redmine/projects/#{context[:project].id}?sort=id")
	tracker_header_tag = content_tag("a","Tracker", :href => "/redmine/projects/#{context[:project].id}?sort=tracker%2Cid")

	table_header_title_list = content_tag("th",id_header_tag) + content_tag("th",tracker_header_tag) + content_tag("th","Status") + content_tag("th","Subject") + content_tag("th","Assigned to") + content_tag("th","Updated") + content_tag("th","Target version") + content_tag("th","Due date") + content_tag("th","% Done")
	table_header_title_list_box = content_tag("tr",table_header_title_list)
	table_header = content_tag("thead",table_header_title_list_box)

	# table record
	table_record_box = nil
	issues.each { |iss|
		id_record_tag = content_tag("a",iss.id, :href => "/redmine/issues/#{iss.id}")
		subject_record_tag = content_tag("a",iss.subject, :href => "/redmine/issues/#{iss.id}")
		user_record_tag = content_tag("a",iss.assigned_to, :href => "/redmine/users/#{User.current.id}")

		table_record = content_tag("td",id_record_tag, :class => "id") + content_tag("td",iss.tracker, :class => "tracker") + content_tag("td",iss.status, :class => "status") + content_tag("td",subject_record_tag, :class => "subject") + content_tag("td",user_record_tag, :class => "assigned_to") + content_tag("td",iss.updated_on, :class => "updated_on") + content_tag("td",iss.fixed_version, :class => "fixed_version") + content_tag("td",iss.due_date, :class => "due_date") + content_tag("td",iss.done_ratio, :class => "done_ratio")
		
		if table_record_box == nil
			table_record_box = content_tag("tr",table_record,:class => "hascontextmenu",:id => "issue-#{iss.id}")
		else 
			table_record_box += content_tag("tr",table_record,:class => "hascontextmenu",:id => "issue-#{iss.id}")
		end
	}
	# table body
	table_body = content_tag("tbody",table_record_box)
	# table
	table_content = table_header + table_body
	# issues list content
	my_list_box_html = content_tag("table",table_content,:class =>"list issues") #test
	# issues list box with scroll
	my_list_box_scroll_html = content_tag("div",my_list_box_html, :class => "autoscroll")
	# fusion tag
	my_fusion_html = my_title_html + my_list_box_scroll_html #test
	# total content tag
	my_content_html = content_tag("ul",nil) + content_tag("div",my_fusion_html, :class => "issues box_2")
	#content_tag("p", issues[0])+content_tag("p", issues[1])
	return my_content_html
  end
end