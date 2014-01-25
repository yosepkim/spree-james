module Spree
	class ProcessController < Spree::StoreController
		helper 'spree/products'
    #respond_to :html
    
		def step1
			#@searcher = build_searcher(params)
      #@products = @searcher.retrieve_products
      
      # get all OS types
      @type = Spree::OptionType.find_by_name('Operating System')
  
      if @type
      	@options = @type.option_values
      else
      	@options = []
      end
		end

		def step2
			session[:selected_os] = params[:selected_value] if ! params[:selected_value].blank?
			@type = Spree::OptionType.where(:name => 'CPU').first
      if @type
      	@options = @type.option_values
      else
      	@options = []
      end
		end

		def step3
			session[:selected_cpu] = params[:selected_value] if ! params[:selected_value].blank?
			@type = Spree::OptionType.where(:name => 'Memory').first
      if @type
      	@options = @type.option_values
      else
      	@options = []
      end
		end
		
		def step4
			session[:selected_memory] = params[:selected_value] if ! params[:selected_value].blank?
			
			os = session[:selected_os]
			cpu = session[:selected_cpu]
			memory = session[:selected_memory]
			
			@variant = Spree::Variant.joins(:option_values).where("spree_option_values.id in (?)", [os, cpu, memory])
				.group('spree_variants.id').having('count(*) = 3').first
			@product = @variant.product
		end
	end
end
