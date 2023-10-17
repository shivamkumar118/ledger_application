# frozen_string_literal: true

class LedgersService
  include LedgerHelper
  include ActionView::Helpers::NumberHelper
  
  def initialize(ledger_type = "complicated")
    @configurable_options = JSON.parse(
      File.read(Rails.root.join("config/configurable_options.json")).gsub(/\n/,
                                                                          "").squeeze(" ")
    ) || {}
    @ledger_type = ledger_type
  end

  def parse_and_format_transactions
    # Picking the ledger list json from configurable_options
    ledger_list = @configurable_options["#{@ledger_type}_ledger"]

    format_transactions(ledger_list)
  end

  def format_transactions(ledger_list)
    # sorting the list according to date and then removing the duplicates from list
    unique_sorted_list = unique_list_for_duplicated_ledgers(sort_by_date(ledger_list))

    final_list = format_required_attributes(unique_sorted_list)

    # the last transaction's balance will be our total balance left
    [number_to_currency(unique_sorted_list&.last&.dig("balance"), precision: 2), final_list]
  end

  def format_required_attributes(ledger_list)
    # adding corresponding description in transactions with other required data which needs to be exposed to frontend
    ledger_list&.map do |ledger|
      {
        date: Date.parse(ledger["date"])&.strftime("%m/%d/%Y"),
        type: ledger["type"],
        description: build_description(ledger),
        amount: number_to_currency(ledger["amount"], precision: 2),
        balance: number_to_currency(ledger["balance"], precision: 2)
      }
    end || []
  end
end

