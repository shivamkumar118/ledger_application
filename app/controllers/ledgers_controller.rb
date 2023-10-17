# frozen_string_literal: true

class LedgersController < ApplicationController
  def index
    total_balance, transactions = ::LedgersService.new(params[:ledger_type]).parse_and_format_transactions
    render json: {"transactions": transactions, "total_balance": total_balance}
  end
end