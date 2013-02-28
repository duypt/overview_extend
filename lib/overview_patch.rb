class OverviewHookListener < Redmine::Hook::ViewListener
  def view_projects_show_left(context={} )
  	# get all issues with conditions
  	# risk tracker_id = 13
  	# hash_conditions
	hash_conditions = {:project_id => context[:project].id,:tracker_id => 1}
	# merge hash_conditions and string_conditions
	conditions = Issue.merge_conditions(hash_conditions) \
				 + 'AND issues.status_id NOT IN (5)' \
				 + 'AND issues.status_id NOT IN (6)'
	# get array of issues
	issues = Issue.find(:all, :conditions => conditions, :order => 'priority_id DESC',:limit => 5)
    # title tag
    my_title_html = content_tag("h3","Top 5 risk issues")
	# table header
	table_header_title_list = content_tag("th","#") \
	 						+ content_tag("th","Tracker") \
	 						+ content_tag("th","Status") \
	 						+ content_tag("th","Subject") \
	 						+ content_tag("th","Assigned to") \
	 						+ content_tag("th","Updated") \
	 						+ content_tag("th","Target version") \
	 						+ content_tag("th","Start date") \
	 						+ content_tag("th","Due date") \
	 						+ content_tag("th","% Done") \
	 						+ content_tag("th","Priority")
	table_header_title_list_box = content_tag("tr",table_header_title_list)
	table_header = content_tag("thead",table_header_title_list_box)
	# table record
	table_record_box = nil
	issues.each { |iss|
		#if issues.index(iss) > 4
		#	break
		#end
		id_record_tag = content_tag("a",iss.id, :href => "/redmine/issues/#{iss.id}")
		subject_record_tag = content_tag("a",iss.subject, :href => "/redmine/issues/#{iss.id}")
		user_record_tag = content_tag("a",iss.assigned_to, :href => "/redmine/users/#{User.current.id}")
		version_record_tag = content_tag("a",iss.fixed_version, :href => "/redmine/version/#{iss.fixed_version_id}")

		table_record = content_tag("td",id_record_tag, :class => "id") \
					   + content_tag("td",iss.tracker, :class => "tracker") \
					   + content_tag("td",iss.status, :class => "status") \
					   + content_tag("td",subject_record_tag, :class => "subject") \
					   + content_tag("td",link_to_user(iss.assigned_to), :class => "assigned_to") \
					   + content_tag("td",iss.updated_on.strftime('%m-%d-%y %H:%M %p'), :class => "updated_on") \
					   + content_tag("td",version_record_tag, :class => "fixed_version") \
					   + content_tag("td",format_date(iss.start_date), :class => "start_date") \
					   + content_tag("td",format_date(iss.due_date), :class => "due_date") \
					   + content_tag("td",progress_bar(iss.done_ratio), :class => "done_ratio") \
					   + content_tag("td",iss.priority, :class => "priority")
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
	my_content_html = '<link rel="stylesheet" type="text/css" href="/redmine/plugin_assets/overview_extend/stylesheets/plugin_class.css">' + content_tag("ul",nil) + content_tag("div",my_fusion_html, :class => "box_2")
	#content_tag("p", issues[0])+content_tag("p", issues[1])
	return my_content_html
  end
end