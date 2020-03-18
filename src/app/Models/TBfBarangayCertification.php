<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBfBarangayCertification
 * 
 * @property int $BARANGAY_CERTIFICATION_ID
 * @property int $ISSUANCE_ID
 * @property int $BF_MAIN_LGU_ID
 * @property int $PAYMENT_DETAILS_ID
 * @property string $ID_PRESENTED
 * @property \Carbon\Carbon $DATE_ISSUE
 * @property string $VALIDITY
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
class TBfBarangayCertification extends Eloquent
{
	protected $table = 't_bf_barangay_certification';
	protected $primaryKey = 'BARANGAY_CERTIFICATION_ID';
	public $timestamps = false;

	protected $casts = [
		'ISSUANCE_ID' => 'int',
		'BF_MAIN_LGU_ID' => 'int',
		'PAYMENT_DETAILS_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'DATE_ISSUE',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'ISSUANCE_ID',
		'BF_MAIN_LGU_ID',
		'PAYMENT_DETAILS_ID',
		'ID_PRESENTED',
		'DATE_ISSUE',
		'VALIDITY',
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
