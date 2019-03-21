require 'activerecord-database-views/view'
require 'activerecord-database-views/view_collection'

module ActiveRecord::DatabaseViews

  def self.register_view_exclusion_filter(proc_handle=nil)
    if proc_handle && proc_handle.respond_to?(:call)
      @view_exclusion_filter = proc_handle
    elsif proc_handle == false
      @view_exclusion_filter = nil
    end
    @view_exclusion_filter
  end

  def self.views(verbose=true, replace=true)
    ViewCollection.new verbose, replace
  end

  def self.without(verbose=true)
    views(verbose).drop!
    yield if block_given?
    views(verbose).load!
  end

  def self.reload!(verbose=true)
    ActiveRecord::Base.transaction do
      without verbose
    end
  end

  # Command: loads all views that don't yet exist
  def self.load!(verbose=true)
    ActiveRecord::Base.transaction do
      views(verbose, false).load!
    end
  end
end
