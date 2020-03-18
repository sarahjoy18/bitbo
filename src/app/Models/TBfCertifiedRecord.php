<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBfCertifiedRecord
 * 
 * @property int $CERTIFIED_RECORD_ID
 * @property int $BF_MAIN_LGU_ID
 * @property int $PAYMENT_DETAILS_ID
 * @property string $RECORD_TYPE_REQUEST
 * @property int $ISSUANCE_ID
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TIssuance $t_issuance
 * @property \App\Models\TBfMainLgu $t_bf_main_lgu
 * @property \App\Models\TBfPaymentDetail $t_bf_payment_detail
 *
 * @package App\Models
 */
class TBfCertifiedRecord extends Eloquent
{
	protected $table = 't_bf_certified_record';
	protected $primaryKey = 'CERTIFIED_RECORD_ID';
	public $timestamps = false;

	protected $casts = [
		'BF_MAIN_LGU_ID' => 'int',
		'PAYMENT_DETAILS_ID' => 'int',
		'ISSUANCE_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'BF_MAIN_LGU_ID',
		'PAYMENT_DETAILS_ID',
		'RECORD_TYPE_REQUEST',
		'ISSUANCE_ID',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
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
