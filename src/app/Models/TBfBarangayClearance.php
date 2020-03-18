<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBfBarangayClearance
 * 
 * @property int $BARANGAY_CLEARANCE_ID
 * @property int $ISSUANCE_ID
 * @property int $BF_MAIN_LGU_ID
 * @property int $PAYMENT_DETAILS_ID
 * @property string $REGISTERED_NAME
 * @property string $KIND_OF_BUSINESS
 * @property string $CONSTRUCTION_ADDRESS
 * @property int $SCOPE_OF_WORK_ID
 * @property string $OCCUPANCY_TYPE
 * @property string $KIND_OF_SIGNAGE
 * @property string $SIGNAGE_WORDINGS
 * @property string $NO_STOREYS_BUILDING
 * @property \Carbon\Carbon $START_DATE_INSTALLATION
 * @property \Carbon\Carbon $END_COMPLETION
 * 
 * @property \App\Models\TIssuance $t_issuance
 * @property \App\Models\TBfMainLgu $t_bf_main_lgu
 * @property \App\Models\TBfPaymentDetail $t_bf_payment_detail
 * @property \App\Models\TBfScopeOfWork $t_bf_scope_of_work
 *
 * @package App\Models
 */
class TBfBarangayClearance extends Eloquent
{
	protected $table = 't_bf_barangay_clearance';
	protected $primaryKey = 'BARANGAY_CLEARANCE_ID';
	public $timestamps = false;

	protected $casts = [
		'ISSUANCE_ID' => 'int',
		'BF_MAIN_LGU_ID' => 'int',
		'PAYMENT_DETAILS_ID' => 'int',
		'SCOPE_OF_WORK_ID' => 'int'
	];

	protected $dates = [
		'START_DATE_INSTALLATION',
		'END_COMPLETION'
	];

	protected $fillable = [
		'ISSUANCE_ID',
		'BF_MAIN_LGU_ID',
		'PAYMENT_DETAILS_ID',
		'REGISTERED_NAME',
		'KIND_OF_BUSINESS',
		'CONSTRUCTION_ADDRESS',
		'SCOPE_OF_WORK_ID',
		'OCCUPANCY_TYPE',
		'KIND_OF_SIGNAGE',
		'SIGNAGE_WORDINGS',
		'NO_STOREYS_BUILDING',
		'START_DATE_INSTALLATION',
		'END_COMPLETION'
	];

	public function t_issuance()
	{
		return $this->belongsTo(\App\Models\TIssuance::class, 'ISSUANCE_ID');
	}

	public function t_bf_main_lgu()
	{
		return $this->belongsTo(\App\Models\TBfMainLgu::class, 'BF_MAIN_LGU_ID');
	}

	public function t_bf_payment_detail()
	{
		return $this->belongsTo(\App\Models\TBfPaymentDetail::class, 'PAYMENT_DETAILS_ID');
	}

	public function t_bf_scope_of_work()
	{
		return $this->belongsTo(\App\Models\TBfScopeOfWork::class, 'SCOPE_OF_WORK_ID');
	}
}
