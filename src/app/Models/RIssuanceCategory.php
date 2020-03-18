<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class RIssuanceCategory
 * 
 * @property int $ISSUANCE_CATEGORY_ID
 * @property string $ISSUANCE_NAME
 * @property string $ISSUANCE_DESCRIPTION
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \Illuminate\Database\Eloquent\Collection $t_issuances
 *
 * @package App\Models
 */
class RIssuanceCategory extends Eloquent
{
	protected $table = 'r_issuance_category';
	protected $primaryKey = 'ISSUANCE_CATEGORY_ID';
	public $timestamps = false;

	protected $casts = [
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'ISSUANCE_NAME',
		'ISSUANCE_DESCRIPTION',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_issuances()
	{
		return $this->hasMany(\App\Models\TIssuance::class, 'ISSUANCE_TYPE_ID');
	}
}
