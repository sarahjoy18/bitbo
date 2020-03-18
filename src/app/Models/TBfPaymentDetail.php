<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBfPaymentDetail
 * 
 * @property int $PAYMENT_DETAILS_ID
 * @property \Carbon\Carbon $RELEASED_DATE
 * @property string $OR_NUMBER
 * @property string $AMOUNT
 * @property \Carbon\Carbon $OR_DATE
 * @property string $PAYMENT_RECEIVED_BY
 * @property \Carbon\Carbon $PAYMENT_DATE_RECEIVED
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
class TBfPaymentDetail extends Eloquent
{
	protected $primaryKey = 'PAYMENT_DETAILS_ID';
	public $timestamps = false;

	protected $casts = [
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'RELEASED_DATE',
		'OR_DATE',
		'PAYMENT_DATE_RECEIVED',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'RELEASED_DATE',
		'OR_NUMBER',
		'AMOUNT',
		'OR_DATE',
		'PAYMENT_RECEIVED_BY',
		'PAYMENT_DATE_RECEIVED',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_bf_barangay_certifications()
	{
		return $this->hasMany(\App\Models\TBfBarangayCertification::class, 'PAYMENT_DETAILS_ID');
	}

	public function t_bf_barangay_clearances()
	{
		return $this->hasMany(\App\Models\TBfBarangayClearance::class, 'PAYMENT_DETAILS_ID');
	}

	public function t_bf_business_permits()
	{
		return $this->hasMany(\App\Models\TBfBusinessPermit::class, 'PAYMENT_DETAILS_ID');
	}

	public function t_bf_certified_records()
	{
		return $this->hasMany(\App\Models\TBfCertifiedRecord::class, 'PAYMENT_DETAILS_ID');
	}
}
