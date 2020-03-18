<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBfMainLgu
 * 
 * @property int $BF_MAIN_LGU_ID
 * @property string $ORIGINAL_TRANSFER_CERTIFICATE_AGENCY
 * @property int $ORIGINAL_TRANSFER_CERTIFICATE_FLAG
 * @property string $TAX_DECLARATION_AGENCY
 * @property int $TAX_DECLARATION_FLAG
 * @property string $CONTRACT_OF_LEASE_AGENCY
 * @property int $CONTRACT_OF_LEASE_FLAG
 * @property string $GROSS_RECEIPT_AGENCY
 * @property int $GROSS_RECEIPT_FLAG
 * @property string $SET_OF_MAP_AGENCY
 * @property int $SET_OF_MAP_FLAG
 * @property string $BILLS_OF_MATERIALS_AGENCY
 * @property int $BILLS_OF_MATERIALS_FLAG
 * @property string $OCCUPANCY_PERMIT_AGENCY
 * @property int $OCCUPANCY_PERMIT_FLAG
 * @property string $OR_OF_TRICYCLE_AGENCY
 * @property int $OR_OF_TRICYCLE_FLAG
 * @property string $PAYMENT_TODA_MEMBERSHIP_AGENCY
 * @property int $PAYMENT_TODA_MEMBERSHIP_FLAG
 * @property string $CTC_AGENCY
 * @property int $CTC_FLAG
 * @property string $BP_BUSINESS_REGISTRATION_AGENCY
 * @property int $BP_BUSINESS_REGISTRATION_FLAG
 * @property string $BP_BUSINESS_CAPITALIZATION_AGENCY
 * @property int $BP_BUSINESS_CAPITALIZATION_FLAG
 * @property string $GROSS_SALES_TAX_AMOUNT
 * @property string $GROSS_SALES_TAX_SURCHARGE
 * @property string $TAX_OR_SIGNBOARD_AMOUNT
 * @property string $TAX_OR_SIGNBOARD_SURCHARGE
 * @property string $PERMIT_FEE_AMOUNT
 * @property string $PERMIT_FEE_SURCHARGE
 * @property int $GARBAGE_CHARGE_AMOUNT
 * @property string $GARBAGE_CHARGE_SURCHARGE
 * @property string $SIGNBOARD_RENEWAL_FEE_AMOUNT
 * @property string $SIGNBOARD_RENEWAL_FEE_SURCHARGE
 * @property string $CTC_AMOUNT
 * @property string $CTC_SURCHARGE
 * @property string $OTHERS_AMOUNT
 * @property string $OTHERS_SURCHARGE
 * @property string $BC_DOCUMENTARY_STAMPS_AMOUNT
 * @property string $BC_DOCUMENTARY_STAMPS_SURCHARGE
 * @property string $BUSINESS_CLUB_AMOUNT
 * @property string $BUSINESS_CLUB_SURCHARGE
 * @property string $CLEARANCE_FEE_AMOUNT
 * @property string $CLEARANCE_FEE_SURCHARGE
 * @property string $VERIFIED_BY
 * @property string $ASSESSED_BY
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_barangay_certifications
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_barangay_clearances
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_business_permits
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_certified_records
 *
 * @package App\Models
 */
class TBfMainLgu extends Eloquent
{
	protected $table = 't_bf_main_lgu';
	protected $primaryKey = 'BF_MAIN_LGU_ID';
	public $timestamps = false;

	protected $casts = [
		'ORIGINAL_TRANSFER_CERTIFICATE_FLAG' => 'int',
		'TAX_DECLARATION_FLAG' => 'int',
		'CONTRACT_OF_LEASE_FLAG' => 'int',
		'GROSS_RECEIPT_FLAG' => 'int',
		'SET_OF_MAP_FLAG' => 'int',
		'BILLS_OF_MATERIALS_FLAG' => 'int',
		'OCCUPANCY_PERMIT_FLAG' => 'int',
		'OR_OF_TRICYCLE_FLAG' => 'int',
		'PAYMENT_TODA_MEMBERSHIP_FLAG' => 'int',
		'CTC_FLAG' => 'int',
		'BP_BUSINESS_REGISTRATION_FLAG' => 'int',
		'BP_BUSINESS_CAPITALIZATION_FLAG' => 'int',
		'GARBAGE_CHARGE_AMOUNT' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'ORIGINAL_TRANSFER_CERTIFICATE_AGENCY',
		'ORIGINAL_TRANSFER_CERTIFICATE_FLAG',
		'TAX_DECLARATION_AGENCY',
		'TAX_DECLARATION_FLAG',
		'CONTRACT_OF_LEASE_AGENCY',
		'CONTRACT_OF_LEASE_FLAG',
		'GROSS_RECEIPT_AGENCY',
		'GROSS_RECEIPT_FLAG',
		'SET_OF_MAP_AGENCY',
		'SET_OF_MAP_FLAG',
		'BILLS_OF_MATERIALS_AGENCY',
		'BILLS_OF_MATERIALS_FLAG',
		'OCCUPANCY_PERMIT_AGENCY',
		'OCCUPANCY_PERMIT_FLAG',
		'OR_OF_TRICYCLE_AGENCY',
		'OR_OF_TRICYCLE_FLAG',
		'PAYMENT_TODA_MEMBERSHIP_AGENCY',
		'PAYMENT_TODA_MEMBERSHIP_FLAG',
		'CTC_AGENCY',
		'CTC_FLAG',
		'BP_BUSINESS_REGISTRATION_AGENCY',
		'BP_BUSINESS_REGISTRATION_FLAG',
		'BP_BUSINESS_CAPITALIZATION_AGENCY',
		'BP_BUSINESS_CAPITALIZATION_FLAG',
		'GROSS_SALES_TAX_AMOUNT',
		'GROSS_SALES_TAX_SURCHARGE',
		'TAX_OR_SIGNBOARD_AMOUNT',
		'TAX_OR_SIGNBOARD_SURCHARGE',
		'PERMIT_FEE_AMOUNT',
		'PERMIT_FEE_SURCHARGE',
		'GARBAGE_CHARGE_AMOUNT',
		'GARBAGE_CHARGE_SURCHARGE',
		'SIGNBOARD_RENEWAL_FEE_AMOUNT',
		'SIGNBOARD_RENEWAL_FEE_SURCHARGE',
		'CTC_AMOUNT',
		'CTC_SURCHARGE',
		'OTHERS_AMOUNT',
		'OTHERS_SURCHARGE',
		'BC_DOCUMENTARY_STAMPS_AMOUNT',
		'BC_DOCUMENTARY_STAMPS_SURCHARGE',
		'BUSINESS_CLUB_AMOUNT',
		'BUSINESS_CLUB_SURCHARGE',
		'CLEARANCE_FEE_AMOUNT',
		'CLEARANCE_FEE_SURCHARGE',
		'VERIFIED_BY',
		'ASSESSED_BY',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_bf_barangay_certifications()
	{
		return $this->hasMany(\App\Models\TBfBarangayCertification::class, 'BF_MAIN_LGU_ID');
	}

	public function t_bf_barangay_clearances()
	{
		return $this->hasMany(\App\Models\TBfBarangayClearance::class, 'BF_MAIN_LGU_ID');
	}

	public function t_bf_business_permits()
	{
		return $this->hasMany(\App\Models\TBfBusinessPermit::class, 'BF_MAIN_LGU_ID');
	}

	public function t_bf_certified_records()
	{
		return $this->hasMany(\App\Models\TBfCertifiedRecord::class, 'BF_MAIN_LGU_ID');
	}
}
