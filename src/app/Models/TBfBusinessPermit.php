<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBfBusinessPermit
 * 
 * @property int $BUSINESS_PERMIT_ID
 * @property int $ISSUANCE_ID
 * @property int $BF_MAIN_LGU_ID
 * @property int $PAYMENT_DETAILS_ID
 * @property string $AMENDMENT_FROM
 * @property string $AMENDMENT_TO
 * @property int $IS_ENJOYING_TAZ_INCENTIVE
 * @property string $SPECIFY_REASON
 * 
 * @property \App\Models\TIssuance $t_issuance
 * @property \App\Models\TBfMainLgu $t_bf_main_lgu
 * @property \App\Models\TBfPaymentDetail $t_bf_payment_detail
 *
 * @package App\Models
 */
class TBfBusinessPermit extends Eloquent
{
	protected $table = 't_bf_business_permit';
	protected $primaryKey = 'BUSINESS_PERMIT_ID';
	public $timestamps = false;

	protected $casts = [
		'ISSUANCE_ID' => 'int',
		'BF_MAIN_LGU_ID' => 'int',
		'PAYMENT_DETAILS_ID' => 'int',
		'IS_ENJOYING_TAZ_INCENTIVE' => 'int'
	];

	protected $fillable = [
		'ISSUANCE_ID',
		'BF_MAIN_LGU_ID',
		'PAYMENT_DETAILS_ID',
		'AMENDMENT_FROM',
		'AMENDMENT_TO',
		'IS_ENJOYING_TAZ_INCENTIVE',
		'SPECIFY_REASON'
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
}
