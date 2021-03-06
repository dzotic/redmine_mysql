# Redmine - project management software
# Copyright (C) 2006-2014  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.expand_path('../../../test_helper', __FILE__)

class QueriesHelperTest < ActionView::TestCase
  include QueriesHelper
  include Redmine::I18n

  fixtures :projects, :enabled_modules, :users, :members,
           :member_roles, :roles, :trackers, :issue_statuses,
           :issue_categories, :enumerations, :issues,
           :watchers, :custom_fields, :custom_values, :versions,
           :queries,
           :projects_trackers,
           :custom_fields_trackers

  def test_filters_options_has_empty_item
    query = IssueQuery.new
    filter_count = query.available_filters.size
    fo = filters_options(query)
    assert_equal filter_count + 1, fo.size
    assert_equal [], fo[0]
  end

  def test_query_to_csv_should_translate_boolean_custom_field_values
    f = IssueCustomField.generate!(:field_format => 'bool', :name => 'Boolean', :is_for_all => true, :trackers => Tracker.all)
    issues = [
      Issue.generate!(:project_id => 1, :tracker_id => 1, :custom_field_values => {f.id.to_s => '0'}),
      Issue.generate!(:project_id => 1, :tracker_id => 1, :custom_field_values => {f.id.to_s => '1'})
    ]

    with_locale 'fr' do
      csv = query_to_csv(issues, IssueQuery.new, :columns => 'all')
      assert_include "Oui", csv
      assert_include "Non", csv
    end
  end
end
